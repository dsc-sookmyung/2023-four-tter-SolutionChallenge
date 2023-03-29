package com.gdsc.forder.dto;

import com.gdsc.forder.domain.User;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.*;


@Data
@Getter
@Setter
@NoArgsConstructor
@ApiModel
public class AddFamilyDTO {

    private String username;
    private String familyName;
    private Long userCode;
    private UserDTO user;
    private UserDTO family;

    @Getter
    @AllArgsConstructor
    public static class reqFamily{
        private final String username;
        private final String familyName;
        private final Long userCode;
    }

    @Getter
    @AllArgsConstructor
    public static class acceptFamily{
        private final UserDTO user;
        private final UserDTO family;
    }
}
