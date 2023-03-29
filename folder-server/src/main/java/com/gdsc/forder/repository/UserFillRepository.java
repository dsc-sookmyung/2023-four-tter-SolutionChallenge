package com.gdsc.forder.repository;

import com.gdsc.forder.domain.User;
import com.gdsc.forder.domain.UserFill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserFillRepository extends JpaRepository<UserFill, Long>, UserFillRepositoryCustom {
    List<UserFill> findByUser(User user);
}
