package com.gdsc.forder.controller;

import com.gdsc.forder.dto.AddCalendarDTO;
import com.gdsc.forder.dto.GetCalendarDTO;
import com.gdsc.forder.dto.GetFillDTO;
import com.gdsc.forder.dto.UserDTO;
import com.gdsc.forder.service.CustomUserDetailService;
import com.gdsc.forder.service.OldService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import org.springframework.web.bind.annotation.*;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import springfox.documentation.annotations.ApiIgnore;

import java.security.Principal;
import java.util.List;

@Api(tags = "메인 화면 API")
@RestController
@RequiredArgsConstructor
@EnableScheduling
@RequestMapping("/")
public class MainController {

    private final OldService oldService;
    private final CustomUserDetailService customUserDetailService;

    @ApiOperation(value = "약 정보 조회 엔드 포인트")
    @GetMapping("old/fillInfo")
    public List<GetFillDTO> getFillInfo(@ApiIgnore Principal principal){
        UserDTO user = customUserDetailService.findUser(principal);
        return oldService.getFillInfo(user.getId());
    }

    @ApiOperation(value = "가족 정보 확인 엔드포인트")
    @GetMapping("family")
    public UserDTO getFamilyInfo(@ApiIgnore Principal principal){
        UserDTO user = customUserDetailService.findUser(principal);
        return oldService.getFamily(user.getFamilyId());
    }


    @ApiOperation(value = "약 복용 여부 체크 엔드 포인트")
    @PatchMapping("old/fillInfo/{fillId}")
    public GetFillDTO checkFill(@ApiIgnore Principal principal, @PathVariable("fillId") long fillId, @RequestParam("accept")Boolean accept){
        UserDTO user = customUserDetailService.findUser(principal);
        oldService.checkFill(user.getId(), fillId, accept);
        return oldService.getPillOne(user.getId(), fillId);
    }


    //매일 새벽 1시 복용 여부 false 로 초기화 해주기
//    @Scheduled(cron = "0 0 1 * * *")
    @ApiOperation(value = "모든 회원들 약 복용 여부 자동 초기화")
    @PatchMapping("old/fillInfo/schedule")
    public void resetFillCheck(){
        oldService.resetFillCheck();
    }


    @ApiOperation(value = "일정 등록 엔드 포인트")
    @ApiResponse(
            code = 200
            , message = "calendarDTO 반환"
    )
    @PostMapping(value = "calendar")
    public GetCalendarDTO saveCalendar(@ApiIgnore Principal principal, @RequestBody AddCalendarDTO addCalendarDTO){
        Long userId = customUserDetailService.findUser(principal).getId();
        return oldService.saveCalendar(userId, addCalendarDTO);
    }


    @ApiOperation(value = "일정 조회 엔드 포인트")
    @ApiResponse(
            code = 200
            , message = "calendarDTO List 반환"
    )
    @GetMapping("calendar")
    public List<GetCalendarDTO> getCalendar(@ApiIgnore Principal principal){
        Long userId = customUserDetailService.findUser(principal).getId();
        return oldService.getCalendar(userId);
    }

    @ApiOperation(value = "일정 수정 엔드 포인트", notes = "수정할 일정의 calendarId를 파라미터로 입력하고, 수정할 내용을 AddCalendarDTO에 맞춰서 작성한다.")
    @ApiResponse(
            code = 200
            , message = "calendarDTO List 반환"
    )
    @PatchMapping("calendar/{calendarId}")
    public GetCalendarDTO modCalendar(@PathVariable("calendarId") long calendarId, @RequestBody AddCalendarDTO addCalendarDTO){
        return oldService.modeCalendar(calendarId, addCalendarDTO);
    }

    @ApiOperation(value = "일정 삭제 엔드 포인트", notes = "삭제할 일정의 calendarId를 파라미터로 전송한다.")
    @ApiResponse(
            code = 200
            , message = "calendarDTO List 반환"
    )
    @DeleteMapping("calendar/{calendarId}")
    public List<GetCalendarDTO>  delCalendar(@ApiIgnore Principal principal, @PathVariable("calendarId") long calendarId){
        Long userId = customUserDetailService.findUser(principal).getId();
        return oldService.delCalendar(userId, calendarId);
    }
}
