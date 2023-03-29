package com.gdsc.forder.repository;

import com.gdsc.forder.domain.Alarm;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AlarmRepository extends JpaRepository<Alarm, Long> {
    Alarm findByTitle(String title);
    Alarm findByTopic(String topic);
}
