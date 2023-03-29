package com.gdsc.forder.repository;

import com.gdsc.forder.domain.Fill;
import com.gdsc.forder.domain.QFill;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalTime;

@Repository
@AllArgsConstructor
public class FillRepositoryImpl implements FillRepositoryCustom {

    private final JPAQueryFactory queryFactory;

    @Override
    public Fill findByOption(String fillName, LocalTime fillTime) {
        return queryFactory.selectFrom(QFill.fill)
                .where(eqFillName(fillName), eqFillTime(fillTime)).fetchOne();
    }

    private BooleanExpression eqFillName(String fillName) {
        if(fillName == null || fillName.isEmpty()) {
            return null;
        }
        return QFill.fill.fillName.eq(fillName);
    }

    private BooleanExpression eqFillTime(LocalTime fillTime) {
        if(fillTime == null) {
            return null;
        }
        return QFill.fill.fillTime.eq(fillTime);
    }

}
