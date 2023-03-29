package com.gdsc.forder.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Data
@Getter
@Setter
@NoArgsConstructor
@ApiModel
public class GetFillDTO {

    @ApiModelProperty
    private Long fillId;

    @ApiModelProperty()
    private String fillName;

    @ApiModelProperty()
    private LocalTime fillTime;

    @ApiModelProperty()
    private Boolean fillCheck;
}
