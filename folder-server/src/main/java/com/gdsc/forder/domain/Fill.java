package com.gdsc.forder.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.*;

import javax.persistence.*;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "fill")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Fill {

    @Id
    @Column(name = "fill_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long Id;

    @JsonIgnore
    @OneToMany(mappedBy = "fill")
    private List<UserFill> users = new ArrayList<>();

    @Column(name = "fill_name", length = 50)
    private String fillName;

    @Column(name = "fill_time")
    private LocalTime fillTime;

}
