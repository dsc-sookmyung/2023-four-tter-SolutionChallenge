package com.gdsc.forder.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Data
@Getter
@Setter
@NoArgsConstructor
@ApiModel
public class EditFillDTO {

    @ApiModelProperty()
    private String fillName;

    @ApiModelProperty(example = "12:00")
    private String fillTime;

}
