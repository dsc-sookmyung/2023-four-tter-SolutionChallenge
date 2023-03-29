package com.gdsc.forder.controller;

import com.gdsc.forder.dto.GetCalendarDTO;
import com.gdsc.forder.dto.GetFillDTO;
import com.gdsc.forder.service.CustomUserDetailService;
import com.gdsc.forder.service.OldService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import springfox.documentation.annotations.ApiIgnore;

import java.security.Principal;
import java.util.List;

@Api(tags = "알림 후 응답값 보내는 API")
@RequiredArgsConstructor
@RequestMapping("/alarm")
@RestController
public class AlarmController {

    private final OldService oldService;
    private final CustomUserDetailService customUserDetailService;


    @ApiOperation(value = "약 복용 여부 수정 엔드 포인트")
    @PatchMapping("pill")
    public List<GetFillDTO> modPillCheck(@ApiIgnore Principal principal, @RequestParam("pill")Boolean pill){
        Long userId = customUserDetailService.findUser(principal).getId();
        return oldService.modPillCheck(userId, pill);
    }

    @ApiOperation(value = "일정 완료 여부 수정 엔드 포인트")
    @PatchMapping("calendar")
    public List<GetCalendarDTO> modCalendarCheck(@ApiIgnore Principal principal, @RequestParam("calendar")Boolean calendar){
        Long userId = customUserDetailService.findUser(principal).getId();
        return oldService.modCalendarCheck(userId, calendar);
    }

}
