package com.gdsc.forder.repository;

import com.gdsc.forder.domain.Fill;
import com.querydsl.jpa.impl.JPAQuery;
import org.springframework.stereotype.Repository;

import java.time.LocalTime;

@Repository
public interface FillRepositoryCustom {
    Fill findByOption(String fillName, LocalTime fillTime);
}
