package cc.mrbird.febs.common.core.exception;

/**
 * FEBS系统异常
 *
 * @author MrBird
 */
public class FebsException extends RuntimeException {

    private static final long serialVersionUID = -6916154462432027437L;

    public FebsException(String message) {
        super(message);
    }
}
