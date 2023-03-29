package com.gdsc.forder.dto;

import com.gdsc.forder.domain.Calendar;
import com.gdsc.forder.domain.User;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@Getter
@Setter
@NoArgsConstructor
@ApiModel
public class AddCalendarDTO {

    @ApiModelProperty()
    private String content;

    @ApiModelProperty(example = "12:00")
    private String calendarTime;

    @ApiModelProperty(example = "2023-03-10")
    private String calendarDate;

    @ApiModelProperty()
    private Boolean calendarCheck;


}
