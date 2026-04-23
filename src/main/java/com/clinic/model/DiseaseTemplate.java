package com.clinic.model;

import java.util.List;
import java.util.ArrayList;

public class DiseaseTemplate {
    private int id;
    private String diseaseName;
    private String icon;
    private String colorTag;
    private String description;
    private List<Medicine> medicines;
    private List<String> adviceList;

    public DiseaseTemplate() {
        this.medicines = new ArrayList<>();
        this.adviceList = new ArrayList<>();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getDiseaseName() { return diseaseName; }
    public void setDiseaseName(String diseaseName) { this.diseaseName = diseaseName; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public String getColorTag() { return colorTag; }
    public void setColorTag(String colorTag) { this.colorTag = colorTag; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public List<Medicine> getMedicines() { return medicines; }
    public void setMedicines(List<Medicine> medicines) { this.medicines = medicines; }

    public List<String> getAdviceList() { return adviceList; }
    public void setAdviceList(List<String> adviceList) { this.adviceList = adviceList; }
}
