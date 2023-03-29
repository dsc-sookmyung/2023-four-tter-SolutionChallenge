package com.gdsc.forder.service;

import com.gdsc.forder.domain.*;
import com.gdsc.forder.dto.*;
import com.gdsc.forder.provider.JwtTokenProvider;
import com.gdsc.forder.repository.FillRepository;
import com.gdsc.forder.repository.UserFamilyRepository;
import com.gdsc.forder.repository.UserFillRepository;
import com.gdsc.forder.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@RequiredArgsConstructor
@Transactional
@Service
public class UserService {

    private final UserRepository userRepository;
    private final FillRepository fillRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    private final UserFillRepository userFillRepository;
    private final UserFamilyRepository userFamilyRepository;

    public UserDTO saveFcmToken(long userId, String fcmToken){
        User user = userRepository.findById(userId).get();
        user.setFcmToken(fcmToken);
        userRepository.save(user);
        return UserDTO.fromEntity(user);
    }

    public void reqFamily(long userId, String familyName, long userCode){

        //친구를 요청 하는 유저
        User user = userRepository.findById(userId).get();
        UserFamily userFamily = new UserFamily();
        userFamily.setUserName(user.getUsername());

        //요청하는 유저의 유저코드
        userFamily.setUserCode(user.getUserCode());

        //요청 대상의 이름
        userFamily.setFamilyName(familyName);

        //요청 대상의 유저코드
        userFamily.setFamilyCode(userCode);
        userFamilyRepository.save(userFamily);
    }

    public GetReqFamilyDTO getFamily(long userId){
        //user가 요청대상임 (userFamily에서의 family)
        User user = userRepository.findById(userId).get();
        GetReqFamilyDTO getReqFamilyDTO = new GetReqFamilyDTO();
        UserFamily userFamily = userFamilyRepository.findByFamilyCode(user.getUserCode());
        if(userFamily == null){
         return getReqFamilyDTO;
        }
        getReqFamilyDTO.setUsername(userFamily.getUserName());
        getReqFamilyDTO.setUserFamilyId(userFamily.getUserFamilyId());
        return getReqFamilyDTO;
    }

    public UserDTO singUp(JoinUserDTO joinUserDTO) throws Exception {
        if (userRepository.findByLoginId(joinUserDTO.getLoginId()).isPresent()){
            throw new IllegalArgumentException("이미 존재하는 아이디입니다.");
        }
        if (!joinUserDTO.getPassword().equals(joinUserDTO.getCheckedPassword())){
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }


        User user = userRepository.save(joinUserDTO.toEntity());

        if(user.getGuard()){
            user.setRole(Role.ROLE_GUARD);
        }
        else{
            user.setRole(Role.ROLE_OLD);
        }
        user.encodePassword(passwordEncoder);

        return UserDTO.fromEntity(user);
    }

    public LoginResponse login(LoginUserDTO users) {
        User user = userRepository.findByLoginId(users.getLoginId())
                .orElseThrow(() -> new IllegalArgumentException("가입되지 않은 아이디 입니다."));

        String password = users.getPassword();
        if (!user.checkPassword(passwordEncoder, password )) {
            throw new IllegalArgumentException("잘못된 비밀번호입니다.");
        }

        List<String> roles = new ArrayList<>();
        roles.add(user.getRoles().toString());

        String accessToken = jwtTokenProvider.createToken(user.getLoginId(), roles);
        Boolean guard = user.getGuard();
        long userId = user.getId();

        LoginResponse loginResponse = new LoginResponse();
        loginResponse.setUserId(userId);
        loginResponse.setGuard(guard);
        loginResponse.setAccessToken(accessToken);
        return loginResponse;
    }

    public void addFill(AddFillDTO addFillDTO, Long userId) {

        List<Fill> fillList = new ArrayList<>();

        List<String> fillNames = addFillDTO.getFills();
        List<LocalTime> fillTimes = StringToTimeConverter(addFillDTO.getFillTimes());

        for(int i=0; i<fillNames.size(); i++){
            Fill fill = new Fill();
            fill.setFillName(fillNames.get(i));
            fill.setFillTime(fillTimes.get(i));
            fillList.add(fill);
        }

        User user = userRepository.findById(userId).get();

        for(int i=0; i<fillList.size(); i++){
            Fill existedFill = fillRepository.findByOption(fillList.get(i).getFillName(), fillList.get(i).getFillTime());
            UserFill userFill = new UserFill();
            userFill.setUser(user);
            if(existedFill != null){
                userFill.setFill(existedFill);
                userFillRepository.save(userFill);
            }
            else {
                fillRepository.save(fillList.get(i));
                userFill.setFill(fillList.get(i));
                userFillRepository.save(userFill);
            }
        }
    }

    public List<LocalTime> StringToTimeConverter(List<String> source) {
        String[] fillTimes = source.toArray(new String[0]);

        List<LocalTime> result = new ArrayList<>();
        for (String s : fillTimes) {
            LocalTime localTime = LocalTime.parse(s);
            result.add(localTime);
        }
        return result;
    }


    public String findByUserCode(Long userCode){
        User family = userRepository.findByUserCode(userCode).get();
        return family.getUsername();
    }

    public UserDTO addFamily(Long userId, Long userFamilyId){

        //로그인한 유저(userFamily에서는 family) - 요청대상
        User user = userRepository.findById(userId).get();

        UserFamily userFamily = userFamilyRepository.findById(userFamilyId).get();


        //요청한 가족
        User family = userRepository.findByUserCode(userFamily.getUserCode()).get();

        user.setFamilyId(family.getId());
        userRepository.save(user);
        family.setFamilyId(userId);
        userRepository.save(family);

        userFamilyRepository.delete(userFamily);
        return UserDTO.fromEntity(family);
    }

    public void editFillInfo(long userId, long fillId, EditFillDTO editFillDTO){

        User user = userRepository.findById(userId).get();

        if(user.getGuard() && user.getFamilyId() !=null){
            User old = userRepository.findById(user.getFamilyId()).get();
            this.editPiiInfo(old, fillId, editFillDTO);
        }
        else{
            this.editPiiInfo(user, fillId, editFillDTO);
        }
    }

    private void editPiiInfo(User user, long fillId, EditFillDTO editFillDTO){

        String fillName = editFillDTO.getFillName();
        String fillTime = editFillDTO.getFillTime();
        LocalTime localTimeFill = LocalTime.parse(fillTime);
        UserFill userFill = new UserFill();
        userFill.setUser(user);

        //수정 대상 약-유저 정보 삭제
        UserFill beforeUserFill = userFillRepository.findByOption(user, fillId);
        userFillRepository.delete(beforeUserFill);

        //DB에 존재 하는 약
        Fill existedFill = fillRepository.findByOption(fillName, localTimeFill);

        if(existedFill != null){
            userFill.setFill(existedFill);
            userFillRepository.save(userFill);
        }

        //존재 하지 않는 약이면 fill 엔티티 새로 생성
        else {
            Fill fill = new Fill();
            fill.setFillTime(localTimeFill);
            fill.setFillName(fillName);
            fillRepository.save(fill);
            userFill.setFill(fill);
            userFillRepository.save(userFill);
        }
    }

    public void deleteFillInfo(long userId, long fillId) {
        User user = userRepository.findById(userId).get();
        if(user.getGuard() && user.getFamilyId() !=null){
            User old = userRepository.findById(user.getFamilyId()).get();
            UserFill userFill = userFillRepository.findByOption(old, fillId);
            userFillRepository.delete(userFill);
        }
        else{
            UserFill userFill = userFillRepository.findByOption(user, fillId);
            userFillRepository.delete(userFill);
        }
    }
}
