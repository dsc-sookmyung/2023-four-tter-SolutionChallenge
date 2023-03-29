package com.gdsc.forder.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.gdsc.forder.domain.Role;
import com.gdsc.forder.domain.User;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import javax.validation.constraints.NotBlank;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ApiModel
public class JoinUserDTO {

    @ApiModelProperty
    @NotBlank(message = "아이디를 입력해주세요.")
    private String loginId;

    @ApiModelProperty
    @NotBlank(message = "이름을 입력해주세요.")
    private String username;

    @ApiModelProperty
    @NotBlank(message = "비밀번호를 입력해주세요")
//    @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,15}$",
//            message = "비밀번호는 8~15 자리이면서 1개 이상의 알파벳, 숫자, 특수문자를 포함해야합니다.")
    private String password;

    private String phone;

    @ApiModelProperty(example = "10:00")
    @JsonFormat(shape= JsonFormat.Shape.STRING, pattern="HH:mm", timezone="Asia/Seoul")
    private LocalTime wakeTime;

    @ApiModelProperty(example = "22:30")
    @JsonFormat(shape= JsonFormat.Shape.STRING, pattern="HH:mm", timezone="Asia/Seoul")
    private LocalTime sleepTime;

    private String checkedPassword;

    @ApiModelProperty(example = "보호자 여부 false/true")
    private Boolean guard;

    @ApiModelProperty()
    private List<String> fills = new ArrayList<>();

    @ApiModelProperty()
    private List<String> fillTimes = new ArrayList<>();


    @Builder
    public User toEntity(){
        return User.builder()
                .loginId(loginId)
                .username(username)
                .password(password)
                .phone(phone)
                .wakeTime(wakeTime)
                .sleepTime(sleepTime)
                .guard(guard)
                .build();
    }
}
