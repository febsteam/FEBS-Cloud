package cc.mrbird.febs.common.logging.starter.configure;

import cc.mrbird.febs.common.logging.starter.aspect.ControllerLogAspect;
import cc.mrbird.febs.common.logging.starter.properties.FebsLogProperties;
import ch.qos.logback.classic.Logger;
import ch.qos.logback.classic.LoggerContext;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import net.logstash.logback.appender.LogstashTcpSocketAppender;
import net.logstash.logback.encoder.LogstashEncoder;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.HashMap;

/**
 * @author xuefrye
 */
@Configuration
@EnableConfigurationProperties(FebsLogProperties.class)
public class FebsLogAutoConfigure {
    private final FebsLogProperties properties;

    @Value("${spring.application.name}")
    private String applicationName;

    public FebsLogAutoConfigure(FebsLogProperties properties) {
        this.properties = properties;
    }

    private static final LoggerContext CONTEXT;
    private static final Logger ROOTLOGGER;

    static {
        CONTEXT = (LoggerContext) LoggerFactory.getILoggerFactory();
        ROOTLOGGER = CONTEXT.getLogger("ROOT");
    }

    @ConditionalOnProperty(name = "febs.log.elk.enable-log-for-controller", havingValue = "true")
    @Bean
    public ControllerLogAspect controllerLogAspect(){
        return new ControllerLogAspect();
    }

    @ConditionalOnProperty(name = "febs.log.elk.enable", havingValue = "true")
    @Bean
    public void enableElk() throws JsonProcessingException {
        LogstashTcpSocketAppender appender = new LogstashTcpSocketAppender();
        LogstashEncoder encoder = new LogstashEncoder();

        HashMap<String, String> customFields = new HashMap<>(2);
        customFields.put("application-name", applicationName);
        String customFieldsString = new ObjectMapper().writeValueAsString(customFields);
        encoder.setCustomFields(customFieldsString);

        appender.setEncoder(encoder);
        appender.addDestination(properties.getLogstashHost());
        appender.setName("logstash[" + applicationName + "]");
        appender.start();
        appender.setContext(CONTEXT);
        ROOTLOGGER.addAppender(appender);
    }
}
