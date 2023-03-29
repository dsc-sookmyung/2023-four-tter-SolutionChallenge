package com.gdsc.forder.repository;

import com.gdsc.forder.domain.Fill;
import com.gdsc.forder.domain.User;
import com.gdsc.forder.domain.UserFill;
import org.springframework.stereotype.Repository;

@Repository
public interface UserFillRepositoryCustom {
    UserFill findByOption(User user, long fillId);
}
