package com.gdsc.forder.dto;

import com.gdsc.forder.domain.Role;
import com.gdsc.forder.domain.User;
import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalTime;


@Data
@ApiModel
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserDTO {

    private Long id;
    private String loginId;
    private String username;
    private Long userCode;
    private LocalTime wakeTime;
    private LocalTime sleepTime;
    private String phone;
    private Long familyId;
    private Role roles;
    private String fcmToken;
    private Boolean guard;

    public static UserDTO fromEntity(User user){
        return UserDTO.builder()
                .id(user.getId())
                .loginId(user.getLoginId())
                .username(user.getUsername())
                .userCode(user.getUserCode())
                .wakeTime(user.getWakeTime())
                .sleepTime(user.getSleepTime())
                .phone(user.getPhone())
                .familyId(user.getFamilyId())
                .roles(user.getRole())
                .fcmToken(user.getFcmToken())
                .guard(user.getGuard())
                .build();
    }
}
