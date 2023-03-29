package com.gdsc.forder.domain;

import lombok.*;

import javax.persistence.*;

@Entity
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserFamily {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userFamilyId;

    //요청하는 유저의 이름
    @Column(name = "user_name")
    private String userName;

    //요청하는 유저의 코드
    @Column(name = "user_code")
    private long userCode;

    //요청 대상
    @Column(name = "family_name")
    private String familyName;

    //요청 대상의 코드
    @Column(name = "family_code")
    private long familyCode;


}
