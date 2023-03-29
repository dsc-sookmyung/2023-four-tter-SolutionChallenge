package com.gdsc.forder.controller;

import com.gdsc.forder.dto.*;
import com.gdsc.forder.service.CustomUserDetailService;
import com.gdsc.forder.service.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import springfox.documentation.annotations.ApiIgnore;

import javax.validation.Valid;
import java.security.Principal;

@Api(tags = "로그인 / 회원가입 API")
@RequiredArgsConstructor
@RequestMapping("/auth")
@RestController
public class AuthController {

    private final UserService userService;
    private final CustomUserDetailService customUserDetailService;

    @GetMapping("/me")
    @ApiOperation(value = "유저 정보 확인 엔드포인트", notes = "유저의 모든 정보를 조회한다.")
    public UserDTO getCurrentUser(@ApiIgnore Principal principal) {
        try{
            return customUserDetailService.findUser(principal);
        }catch (NullPointerException e){
            throw e;
        }
    }


    //회원가입
    @PostMapping("/join")
    @ApiResponse(
            code = 200
            , message = "accessToken, userDTO 반환"
    )
    @ApiOperation(value = "회원가입 엔드포인트" , notes =
            "JoinUserDTO에 맞춰서 requestBody로 회원정보를 입력한다." +
                    "fills와 fillTimes (HH:mm) 는 string 배열로 보낸다.")
    public SignInDTO join(@Valid @RequestBody JoinUserDTO joinUserDTO) throws Exception {

        UserDTO user = userService.singUp(joinUserDTO);
        Long userId = user.getId();

        AddFillDTO addFillDTO = new AddFillDTO();

        if(joinUserDTO.getFills().size() > 0){
            addFillDTO.setFills(joinUserDTO.getFills());
            addFillDTO.setFillTimes(joinUserDTO.getFillTimes());
            userService.addFill(addFillDTO, userId);
        }

//        if(addFillDTO.getFills().size() > 0){
//            userService.addFill(addFillDTO, userId);
//        }

        LoginUserDTO loginUserDTO = new LoginUserDTO();
        loginUserDTO.setLoginId(joinUserDTO.getLoginId());
        loginUserDTO.setPassword(joinUserDTO.getPassword());
        String accessToken = userService.login(loginUserDTO).getAccessToken();

        return new SignInDTO(accessToken, user);
    }


    @PostMapping("/login")
    @ApiResponse(
            code = 200
            , message = "accessToken 발급"
    )
    @ApiOperation(value = "로그인 엔드포인트", notes = "LoginUserDTO에 맞춰서 아이디와 비밀번호를 입력한다.")
    public LoginResponse login(@RequestBody LoginUserDTO loginUserDTO) {
        return userService.login(loginUserDTO);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<String> handleIllegalArgumentException(IllegalArgumentException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
    }

    @ApiOperation(value = "fcmToken 저장 엔드포인트", notes = "RequestBody에 fcmToken을 입력한다.")
    @PostMapping("/fcm")
    public UserDTO fcm(@ApiIgnore Principal principal, @RequestBody String fcmToken){
        UserDTO user = customUserDetailService.findUser(principal);
        return userService.saveFcmToken(user.getId(), fcmToken);
    }
}
