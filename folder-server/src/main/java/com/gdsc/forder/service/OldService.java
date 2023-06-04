package com.gdsc.forder.service;


import com.gdsc.forder.domain.Calendar;
import com.gdsc.forder.domain.Fill;
import com.gdsc.forder.domain.User;
import com.gdsc.forder.domain.UserFill;
import com.gdsc.forder.dto.AddCalendarDTO;
import com.gdsc.forder.dto.GetCalendarDTO;
import com.gdsc.forder.dto.GetFillDTO;
import com.gdsc.forder.dto.UserDTO;
import com.gdsc.forder.repository.CalendarRepository;
import com.gdsc.forder.repository.FillRepository;
import com.gdsc.forder.repository.UserFillRepository;
import com.gdsc.forder.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import javax.transaction.Transactional;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@RequiredArgsConstructor
@Transactional
@Service
public class OldService {

    private final UserRepository userRepository;
    private final FillRepository fillRepository;
    private final UserFillRepository userFillRepository;
    private final CalendarRepository calendarRepository;

    public UserDTO getFamily(Long userId){
        User user = userRepository.findById(userId).get();
        return UserDTO.fromEntity(user);
    }

    public List<GetFillDTO> getFillInfo(Long userId){
        User user = userRepository.findById(userId).get();
        if(user.getGuard() && user.getFamilyId() !=null){
            User old = userRepository.findById(user.getFamilyId()).get();
            List<UserFill> oldFills = userFillRepository.findByUser(old);
            return this.getPillInfo(oldFills);
        }
        else{
            List<UserFill> userFills = userFillRepository.findByUser(user);
            return this.getPillInfo(userFills);
        }
    }

    private List<GetFillDTO> getPillInfo(List<UserFill> userFills) {
        List<GetFillDTO> result = new ArrayList<>();
        for (int i = 0; i < userFills.size(); i++) {
            GetFillDTO fillDTO = new GetFillDTO();
            fillDTO.setFillId(userFills.get(i).getFill().getId());
            fillDTO.setFillName(userFills.get(i).getFill().getFillName());
            fillDTO.setFillTime(userFills.get(i).getFill().getFillTime());
            fillDTO.setFillCheck(userFills.get(i).getFillCheck());
            result.add(fillDTO);
        }
        return result;
    }

//    public List<GetFillDTO> getFillInfo(Long userId) {
//        User user = userRepository.findById(userId).get();
//        List<UserFill> userFills = userFillRepository.findByUser(user);
//
//        List<GetFillDTO> result = new ArrayList<>();
//        for (int i = 0; i < userFills.size(); i++) {
//            GetFillDTO fillDTO = new GetFillDTO();
//            fillDTO.setFillId(userFills.get(i).getFill().getId());
//            fillDTO.setFillName(userFills.get(i).getFill().getFillName());
//            fillDTO.setFillTime(userFills.get(i).getFill().getFillTime());
//            fillDTO.setFillCheck(userFills.get(i).getFillCheck());
//            result.add(fillDTO);
//        }
//        return result;
//    }

    public void checkFill(long userId, long fillId, Boolean accept) {
        User user = userRepository.findById(userId).get();
        if(user.getGuard() && user.getFamilyId() !=null){
            User old = userRepository.findById(user.getFamilyId()).get();
            UserFill userFill = userFillRepository.findByOption(old, fillId);
            this.checkFillSave(userFill, accept);
        }
        else{
            UserFill userFill = userFillRepository.findByOption(user, fillId);
            this.checkFillSave(userFill, accept);
        }
    }

    private void checkFillSave(UserFill userPill, Boolean accept){
        userPill.setFillCheck(accept);
        userFillRepository.save(userPill);
    }

    public GetFillDTO getPillOne(long userId, long fillId){
        User user = userRepository.findById(userId).get();
        Fill fill = fillRepository.findById(fillId).get();
        if(user.getGuard() && user.getFamilyId() != null){
            User old = userRepository.findById(user.getFamilyId()).get();
            UserFill userFill = userFillRepository.findByOption(old, fillId);
            return this.getFillOne(userFill, fill);
        }
        else{
            UserFill userFill = userFillRepository.findByOption(user, fillId);
            return this.getFillOne(userFill, fill);
        }
    }

    private GetFillDTO getFillOne(UserFill userFill, Fill pill) {
        GetFillDTO getFillDTO = new GetFillDTO();
        getFillDTO.setFillId(pill.getId());
        getFillDTO.setFillTime(pill.getFillTime());
        getFillDTO.setFillCheck(userFill.getFillCheck());
        getFillDTO.setFillName(pill.getFillName());
        return getFillDTO;
    }


    public GetCalendarDTO saveCalendar(Long userId, AddCalendarDTO addCalendarDTO) {
        User user = userRepository.findById(userId).get();
        Calendar calendar = new Calendar();

        if(user.getGuard()){
            User old = userRepository.findById(user.getFamilyId()).get();
            calendar.setUser(old);
        }
        else{
            calendar.setUser(user);
        }

        LocalDate date = LocalDate.parse(addCalendarDTO.getCalendarDate(), DateTimeFormatter.ISO_DATE);
        calendar.setCalendarDate(date);

        String calendarTime = addCalendarDTO.getCalendarTime();
        LocalTime localTimeCalendar = LocalTime.parse(calendarTime);

        calendar.setCalendarTime(localTimeCalendar);
        calendar.setContent(addCalendarDTO.getContent());
        calendar.setCalendarCheck(addCalendarDTO.getCalendarCheck());
        calendarRepository.save(calendar);

        GetCalendarDTO result = new GetCalendarDTO();
        result.setCalendarId(calendar.getCalendarId());
        result.setCalendarDate(calendar.getCalendarDate());
        result.setContent(calendar.getContent());
        result.setCalendarTime(calendar.getCalendarTime().toString());
        result.setCalendarCheck(false);
        result.setUserId(calendar.getUser().getId());
        result.setUserName(user.getUsername());
        return result;
    }


    public List<GetCalendarDTO>  getCalendar(Long userId) {
        User user = userRepository.findById(userId).get();
        if(user.getGuard() && user.getFamilyId() !=null){
            User old = userRepository.findById(user.getFamilyId()).get();
            List<Calendar> oldCalendar = calendarRepository.findByUser(old);
            return this.getCalendarDto(oldCalendar);
        }
        else {
            List<Calendar> oldCalendar = calendarRepository.findByUser(user);
            return this.getCalendarDto(oldCalendar);
        }
    }

    private List<GetCalendarDTO> getCalendarDto(List<Calendar> calendar){
        List<GetCalendarDTO> result = new ArrayList<>();
        if (!calendar.isEmpty()) {
            for (int i = 0; i < calendar.size(); i++) {
                GetCalendarDTO calendarDTO = new GetCalendarDTO();

                calendarDTO.setCalendarId(calendar.get(i).getCalendarId());
                calendarDTO.setCalendarDate(calendar.get(i).getCalendarDate());
                calendarDTO.setContent(calendar.get(i).getContent());
                calendarDTO.setCalendarTime(calendar.get(i).getCalendarTime().toString());
                calendarDTO.setCalendarCheck(calendar.get(i).getCalendarCheck());
                calendarDTO.setUserId(calendar.get(i).getUser().getId());
                calendarDTO.setUserName(calendar.get(i).getUser().getUsername());
                result.add(calendarDTO);
            }
        }
        return result;
    }

    public GetCalendarDTO modeCalendar(Long calendarId, AddCalendarDTO addCalendarDTO) {

        Calendar calendar = calendarRepository.findById(calendarId).get();

        LocalDate date = LocalDate.parse(addCalendarDTO.getCalendarDate(), DateTimeFormatter.ISO_DATE);
        calendar.setCalendarDate(date);

        String calendarTime = addCalendarDTO.getCalendarTime();
        LocalTime localTimeCalendar = LocalTime.parse(calendarTime);

        calendar.setCalendarTime(localTimeCalendar);
        calendar.setContent(addCalendarDTO.getContent());
        calendar.setCalendarCheck(addCalendarDTO.getCalendarCheck());

        calendarRepository.save(calendar);

        GetCalendarDTO result = new GetCalendarDTO();
        result.setCalendarId(calendar.getCalendarId());
        result.setCalendarDate(calendar.getCalendarDate());
        result.setContent(calendar.getContent());
        result.setCalendarTime(calendar.getCalendarTime().toString());
        result.setCalendarCheck(calendar.getCalendarCheck());

        return result;
    }


    public List<GetCalendarDTO> delCalendar(Long userId, Long calendarId) {
        Calendar calendar = calendarRepository.findById(calendarId).get();
        calendarRepository.delete(calendar);
        return this.getCalendar(userId);
    }

    public void resetFillCheck() {
        List<UserFill> userFills = userFillRepository.findAll();
        for (int i = 0; i < userFills.size(); i++) {
            userFills.get(i).setFillCheck(false);
            userFillRepository.save(userFills.get(i));
        }
    }

    public List<GetFillDTO> modPillCheck(Long userId, Boolean pill) {
        User user = userRepository.findById(userId).get();
        List<UserFill> userFills = userFillRepository.findByUser(user);

        for (int i = 0; i < userFills.size(); i++) {
            userFills.get(i).setFillCheck(pill);
            userFillRepository.save(userFills.get(i));
        }
        return this.getFillInfo(userId);
    }

    public List<GetCalendarDTO> modCalendarCheck(Long userId, Boolean calendar) {
        User user = userRepository.findById(userId).get();
        List<Calendar> calendars = calendarRepository.findByUser(user);

        for(int i=0; i< calendars.size(); i++){
            calendars.get(i).setCalendarCheck(calendar);
            calendarRepository.save(calendars.get(i));
        }
        return this.getCalendar(userId);
    }
}
