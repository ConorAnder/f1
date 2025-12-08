void initButtons() {
    float button_height = (button_height_bottom - button_height_top) / 9.0;
    rectMode(CORNERS);
    stroke(stroke);
    strokeWeight(3);
    textFont(f1_font);
    textSize(30);
    textAlign(CENTER, TOP);

    String[] drivers = {"Dry", "Hamilton", "Leclerc", "Tsunoda", "Russell"};

    for (int i = 0; i < 9; i += 2) {
        float current_height = button_height_top + i * button_height;
        fill(primary1);
        rect(button_width_left, current_height, button_width_right, current_height + button_height);
        fill(primary2);
        text(drivers[i / 2], (button_width_left + button_width_right) / 2.0, current_height + 0.5 * button_height - 10);
    }
}

void select(int selection) {
    switch (selection) {
        case 0:
            break;

        case 1:
            break;
        
        case 2:
            break;

        case 3:
            break;

        default:
            break;
    }
}