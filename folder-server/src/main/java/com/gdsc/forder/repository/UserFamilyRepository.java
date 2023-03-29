package com.gdsc.forder.repository;

import com.gdsc.forder.domain.UserFamily;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserFamilyRepository extends JpaRepository<UserFamily, Long> {
    UserFamily findByFamilyCode(long familyCode);
}
