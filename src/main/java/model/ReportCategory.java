package model;

import java.io.Serializable;

public class ReportCategory implements Serializable {
    private int categoryID;
    private String code;
    private String displayName;
    private boolean isActive;

    public ReportCategory() {
    }

    public ReportCategory(int categoryID, String code, String displayName, boolean isActive) {
        this.categoryID = categoryID;
        this.code = code;
        this.displayName = displayName;
        this.isActive = isActive;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}

