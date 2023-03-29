package com.gdsc.forder.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
public class PushNotificationDTO {

    private String title;
    private String message;
    private String topic;
    private String token;


}
