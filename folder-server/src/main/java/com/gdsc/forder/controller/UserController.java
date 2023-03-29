package com.gdsc.forder.controller;

import com.gdsc.forder.domain.UserFamily;
import com.gdsc.forder.dto.*;
import com.gdsc.forder.service.CustomUserDetailService;
import com.gdsc.forder.service.OldService;
import com.gdsc.forder.service.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import springfox.documentation.annotations.ApiIgnore;

import java.security.Principal;
import java.util.List;

@Api(tags = "마이 페이지 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("my-page")
public class UserController {

    private final UserService userService;
    private final OldService oldService;
    private final CustomUserDetailService customUserDetailService;

    @PostMapping("/family")
    @ApiOperation(value = "보호자/대상 추가 요청 엔드포인트", notes = "userCode에는 요청대상의 userCode를 작성한다. 보호자면 노인의 유저코드, 노인이면 보호자의 유저코드")
    public AddFamilyDTO.reqFamily  reqFamily(@ApiIgnore Principal principal, @RequestParam("userCode")Long userCode) {
        UserDTO user = customUserDetailService.findUser(principal);
        String userName = user.getUsername();
        String familyName = userService.findByUserCode(userCode);

        userService.reqFamily(user.getId(), familyName, userCode);

        return new AddFamilyDTO.reqFamily(userName,familyName, userCode);
    }

    @GetMapping("/family")
    @ApiOperation(value = "보호자/대상 추가 요청 조회 엔드 포인트", notes = "요청이 없으면 userFamilyId가 0, userName이 null로 뜬다.")
    public GetReqFamilyDTO getFamily(@ApiIgnore Principal principal) {
        UserDTO user = customUserDetailService.findUser(principal);
        return userService.getFamily(user.getId());

//        return new AddFamilyDTO.reqFamily(userName,familyName, userCode);
    }

    @PatchMapping("/family")
    @ApiOperation(value = "보호자/대상 추가 수락 여부 엔드 포인트", notes = "수락할 요청의 userFamilyId를 입력한다.")
    public AddFamilyDTO.acceptFamily addFamily(@ApiIgnore Principal principal, @RequestParam("accept")Boolean accept, @RequestParam("userFamilyId")Long userFamilyId ) {
        UserDTO user = customUserDetailService.findUser(principal);
        if(accept){
            UserDTO family = userService.addFamily(user.getId(), userFamilyId);
            user.setFamilyId(family.getId());
            return new AddFamilyDTO.acceptFamily(user, family);
        }
        return new AddFamilyDTO.acceptFamily(user, null);
    }

    @GetMapping("/fillInfo")
    @ApiOperation(value = "약 복용 일지 조회 엔드 포인트 (마이 페이지)")
    public List<GetFillDTO> getFillInfo(@ApiIgnore Principal principal) {
        UserDTO user = customUserDetailService.findUser(principal);
        return oldService.getFillInfo(user.getId());
    }

    @PostMapping("/fillInfo/{fillId}")
    @ApiOperation(value = "약 복용 일지 수정 엔드 포인트")
    public List<GetFillDTO> editFillInfo(@ApiIgnore Principal principal, @PathVariable("fillId") long fillId, @RequestBody EditFillDTO editFillDTO) {
        UserDTO user = customUserDetailService.findUser(principal);
        userService.editFillInfo(user.getId(), fillId, editFillDTO);
        return oldService.getFillInfo(user.getId());
    }

    @DeleteMapping("/fillInfo/{fillId}")
    @ApiOperation(value = "약 복용 일지 삭제 엔드 포인트")
    public List<GetFillDTO> deleteFillInfo(@ApiIgnore Principal principal, @PathVariable("fillId") long fillId) {
        UserDTO user = customUserDetailService.findUser(principal);
        userService.deleteFillInfo(user.getId(), fillId);
        return oldService.getFillInfo(user.getId());
    }

    @PostMapping("/fillInfo")
    @ApiOperation(value = "약 복용 일지 추가 엔드 포인트", notes = "{\n" +
            "  \"fillTimes\": [\"11:00\",\"12:30\"],\n" +
            "  \"fills\": [\n" +
            "    \"add1\",\n" +
            "\"add2\"\n" +
            "  ]\n" +
            "} 형태로 작성")
    public List<GetFillDTO> addFillInfo(@ApiIgnore Principal principal, @RequestBody AddFillDTO addFillDTO) {
        UserDTO user = customUserDetailService.findUser(principal);
        if(user.getGuard() && user.getFamilyId() !=null){
            userService.addFill(addFillDTO, user.getFamilyId());
        }
        else{
            userService.addFill(addFillDTO, user.getId());
        }
//        if(addFillDTO.getFills().size() > 0){
//            userService.addFill(addFillDTO, user.getId());
//        }
        return oldService.getFillInfo(user.getId());
    }
}
