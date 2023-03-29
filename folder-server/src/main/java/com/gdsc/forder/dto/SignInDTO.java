package com.gdsc.forder.dto;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class SignInDTO {

    private String accessToken;
    private UserDTO user;

}
