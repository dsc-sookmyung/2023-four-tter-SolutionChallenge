package com.gdsc.forder.service;

import com.gdsc.forder.domain.User;
import com.gdsc.forder.domain.UserDetailImpl;
import com.gdsc.forder.dto.UserDTO;
import com.gdsc.forder.repository.UserRepository;
import lombok.RequiredArgsConstructor;

import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.security.Principal;


@RequiredArgsConstructor
@Service
@Slf4j
public class CustomUserDetailService implements UserDetailsService {

    private final UserRepository userRepository;

    public UserDTO findUser(Principal principal){
        User user = userRepository.findByLoginId(principal.getName()).get();
        return UserDTO.fromEntity(user);
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return userRepository.findByLoginId(username)
                .map(UserDetailImpl::new)
                .orElseThrow(()-> new UsernameNotFoundException("사용자를 찾을 수 없습니다"));
    }
}
