package com.gdsc.forder.repository;

import com.gdsc.forder.domain.Alarm;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AlarmRepository extends JpaRepository<Alarm, Long> {
    Alarm findByTitle(String title);
    Alarm findByTopic(String topic);
    List<Optional<Alarm>> findByUser(String user);
}
