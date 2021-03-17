package cc.mrbird.febs.common.security.starter.configure;

import cc.mrbird.febs.common.core.entity.constant.EndpointConstant;
import cc.mrbird.febs.common.core.entity.constant.StringConstant;
import cc.mrbird.febs.common.security.starter.handler.FebsAccessDeniedHandler;
import cc.mrbird.febs.common.security.starter.handler.FebsAuthExceptionEntryPoint;
import cc.mrbird.febs.common.security.starter.properties.FebsCloudSecurityProperties;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.security.servlet.UserDetailsServiceAutoConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.oauth2.config.annotation.web.configuration.EnableResourceServer;
import org.springframework.security.oauth2.config.annotation.web.configuration.ResourceServerConfigurerAdapter;
import org.springframework.security.oauth2.config.annotation.web.configurers.ResourceServerSecurityConfigurer;

/**
 * @author MrBird
 */
@EnableResourceServer
@EnableAutoConfiguration(exclude = UserDetailsServiceAutoConfiguration.class)
public class FebsCloudResourceServerConfigure extends ResourceServerConfigurerAdapter {

    private FebsCloudSecurityProperties properties;
    private FebsAccessDeniedHandler accessDeniedHandler;
    private FebsAuthExceptionEntryPoint exceptionEntryPoint;

    @Autowired(required = false)
    public void setProperties(FebsCloudSecurityProperties properties) {
        this.properties = properties;
    }

    @Autowired(required = false)
    public void setAccessDeniedHandler(FebsAccessDeniedHandler accessDeniedHandler) {
        this.accessDeniedHandler = accessDeniedHandler;
    }

    @Autowired(required = false)
    public void setExceptionEntryPoint(FebsAuthExceptionEntryPoint exceptionEntryPoint) {
        this.exceptionEntryPoint = exceptionEntryPoint;
    }

    @Override
    public void configure(HttpSecurity http) throws Exception {
        if (properties == null) {
            permitAll(http);
            return;
        }
        String[] anonUrls = StringUtils.splitByWholeSeparatorPreserveAllTokens(properties.getAnonUris(), StringConstant.COMMA);
        if (ArrayUtils.isEmpty(anonUrls)) {
            anonUrls = new String[]{};
        }
        if (ArrayUtils.contains(anonUrls, EndpointConstant.ALL)) {
            permitAll(http);
            return;
        }
        http.csrf().disable()
                .requestMatchers().antMatchers(properties.getAuthUri())
                .and()
                .authorizeRequests()
                .antMatchers(anonUrls).permitAll()
                .antMatchers(properties.getAuthUri()).authenticated()
                .and()
                .httpBasic();
    }

    @Override
    public void configure(ResourceServerSecurityConfigurer resources) {
        if (exceptionEntryPoint != null) {
            resources.authenticationEntryPoint(exceptionEntryPoint);
        }
        if (accessDeniedHandler != null) {
            resources.accessDeniedHandler(accessDeniedHandler);
        }
    }

    private void permitAll(HttpSecurity http) throws Exception {
        http.csrf().disable();
        http.authorizeRequests().anyRequest().permitAll();
    }
}
