package com.gdsc.forder.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import javax.persistence.*;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;


@Entity
@Table(name = "users")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class User {

    @Id
    @Column(name = "user_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long Id;

    @Column(name = "family_id")
    private Long familyId;

    @Column(name = "login_id", length = 50, unique = true)
    private String loginId;

    @Column(name = "password", length = 200)
    private String password;

    @Column(name = "user_name", length = 50)
    private String username;

    @Enumerated(EnumType.STRING)
    @Column()
    private Role role;

    @Column(nullable = false)
    private Boolean guard;

    @Column(name = "user_code", unique = true)
    private long userCode;

    @Column(name = "phone", length = 50)
    private String phone;

    @Column(name = "wake_time")
    private LocalTime wakeTime;

    @Column(name = "sleep_time")
    private LocalTime sleepTime;

    @JsonIgnore
    @OneToMany(mappedBy = "user")
    private List<UserFill> fills = new ArrayList<>();

    @JsonIgnore
    @OneToMany(mappedBy = "user")
    private List<Calendar> calendar = new ArrayList<>();

    @Column(name="fcm_token", length = 200)
    private String fcmToken;

    @PrePersist
    public void setUserCode(){
        long random = LocalTime.now().getNano();
        this.userCode = random;
    }

    public Role getRoles() {
        return this.role;
    }

    public Set<GrantedAuthority> getAuthorities() {
        Set<GrantedAuthority> authorities = new HashSet<>();
        authorities.add(new SimpleGrantedAuthority(this.role.name()));
        return authorities;
    }

    public void encodePassword(BCryptPasswordEncoder passwordEncoder){
        this.password = passwordEncoder.encode(password);
    }

    public boolean checkPassword(BCryptPasswordEncoder passwordEncoder, String input_password) {
        return passwordEncoder.matches(input_password, this.password);
    }
}
