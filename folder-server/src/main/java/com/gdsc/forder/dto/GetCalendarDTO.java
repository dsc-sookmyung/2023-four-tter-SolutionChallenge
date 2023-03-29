package com.gdsc.forder.dto;


import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@Getter
@Setter
@NoArgsConstructor
@ApiModel
public class GetCalendarDTO {

    @ApiModelProperty
    private Long calendarId;

    @ApiModelProperty
    private String content;

    @ApiModelProperty(example = "12:30")
    private String calendarTime;

    @ApiModelProperty(example = "2023-03-10")
    private LocalDate calendarDate;

    @ApiModelProperty
    private Boolean calendarCheck;

    @ApiModelProperty
    private String userName;

    @ApiModelProperty
    private long userId;


}
