package com.gdsc.forder.repository;

import com.gdsc.forder.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByLoginId(String loginId);
    Optional<User> findById(Long id);
    Optional<User> findByUserCode(Long userCode);
}
