package com.gdsc.forder.repository;

import com.gdsc.forder.domain.*;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Repository;


@Repository
@AllArgsConstructor
public class UserFillRepositoryImpl implements UserFillRepositoryCustom{

    private final JPAQueryFactory queryFactory;

    @Override
    public UserFill findByOption(User user, long fill) {
        return queryFactory.selectFrom(QUserFill.userFill)
                .where(eqFill(fill), eqUser(user)).fetchOne();
    }

    private BooleanExpression eqFill(long fill) {
        return QFill.fill.Id.eq(fill);
    }

    private BooleanExpression eqUser(User user) {
        if(user == null) {
            return null;
        }
        return QUser.user.eq(user);
    }
}
