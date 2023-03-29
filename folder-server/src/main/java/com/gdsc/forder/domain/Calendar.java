package com.gdsc.forder.domain;

import com.google.api.client.util.DateTime;
import lombok.*;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "calender")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Calendar {

    @Id
    @Column(name="calendar_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long CalendarId;

    @ManyToOne
    @JoinColumn(name="user_id")
    private User user;

    @Column(name="calendar_date")
    private LocalDate calendarDate;

    @Column(name="content")
    private String content;

    @Column(name="calender_time")
    private LocalTime calendarTime;

    @Column(name = "calender_check")
    private Boolean calendarCheck;

}
