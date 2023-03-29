package com.gdsc.forder.repository;

import com.gdsc.forder.domain.Calendar;
import com.gdsc.forder.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface CalendarRepository extends JpaRepository<Calendar, Long> {
    List<Calendar> findByUser(User user);
}
