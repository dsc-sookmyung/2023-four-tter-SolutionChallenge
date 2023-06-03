package com.gdsc.forder.domain;

import lombok.*;

import javax.persistence.*;
import java.time.LocalTime;

@Entity
@Table(name = "alarm")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Alarm {

    @Id
    @Column(name = "alarm_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long Id;

    @Column(name = "title", length = 50)
    private String title;

    @Column(name = "message", length = 50)
    private String message;

    @Column(name = "topic", length = 50)
    private String topic;

//    @ManyToOne
//    @JoinColumn(name="user_id")
    @Column(name = "user")
    private String user;

    @Column(name = "alarm_time")
    private String alarmTime;

}
