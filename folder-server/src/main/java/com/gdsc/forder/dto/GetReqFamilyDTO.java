package com.gdsc.forder.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.annotation.Nullable;

@Data
@ApiModel
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GetReqFamilyDTO {

    @ApiModelProperty(value = "친구 요청 기본키")
    private long userFamilyId;
//친구요청한 유저의 이름
    @Nullable()
    @ApiModelProperty(value = "요청한 유저의 이름")
    private String username;
    //친구요청한 유저의 코드

//    @ApiModelProperty(value = "요청한 유저의 코드")
//    private long userCode;

}
