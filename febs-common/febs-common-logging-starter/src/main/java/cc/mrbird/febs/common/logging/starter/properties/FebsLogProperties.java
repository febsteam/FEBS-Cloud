package cc.mrbird.febs.common.logging.starter.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * @author xuefrye
 */
@ConfigurationProperties(prefix = "febs.log.elk")
public class FebsLogProperties {
    /**
     * 日志上传地址
     */
    private String logstashHost;

    /**
     * 是否开启controller层api调用的日志
     */
    private Boolean enableLogForController;

    /**
     * 是否开启ELK日志收集
     */
    private Boolean enable;

    public String getLogstashHost() {
        return logstashHost;
    }

    public void setLogstashHost(String logstashHost) {
        this.logstashHost = logstashHost;
    }

    public Boolean getEnableLogForController() {
        return enableLogForController;
    }

    public void setEnableLogForController(Boolean enableLogForController) {
        this.enableLogForController = enableLogForController;
    }

    public Boolean getEnable() {
        return enable;
    }

    public void setEnable(Boolean enable) {
        this.enable = enable;
    }
}
