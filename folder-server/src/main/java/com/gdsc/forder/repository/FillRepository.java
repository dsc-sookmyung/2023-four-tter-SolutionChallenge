package com.gdsc.forder.repository;

import com.gdsc.forder.domain.Fill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FillRepository extends JpaRepository<Fill, Long>, FillRepositoryCustom {
}
