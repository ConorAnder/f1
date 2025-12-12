void select(int selection) {
    switch (selection) {
        case 0:
            plotButton(0, primary2, drivers[0], primary1);
            plotButton(1, primary1, drivers[1], primary2);
            plotButton(2, primary1, drivers[2], primary2);
            plotButton(3, primary1, drivers[3], primary2);
            plotButton(4, secondary, drivers[4], primary2);
            break;

        case 1:
            plotButton(0, primary1, drivers[0], primary2);
            plotButton(1, primary2, drivers[1], primary1);
            plotButton(2, primary1, drivers[2], primary2);
            plotButton(3, primary1, drivers[3], primary2);
            plotButton(4, secondary, drivers[4], primary2);
            break;
        
        case 2:
            plotButton(0, primary1, drivers[0], primary2);
            plotButton(1, primary1, drivers[1], primary2);
            plotButton(2, primary2, drivers[2], primary1);
            plotButton(3, primary1, drivers[3], primary2);
            plotButton(4, secondary, drivers[4], primary2);
            break;

        case 3:
            plotButton(0, primary1, drivers[0], primary2);
            plotButton(1, primary1, drivers[1], primary2);
            plotButton(2, primary1, drivers[2], primary2);
            plotButton(3, primary2, drivers[3], primary1);
            plotButton(4, secondary, drivers[4], primary2);
            break;

        default:
            plotButton(0, primary2, drivers[0], primary1);
            plotButton(1, primary1, drivers[1], primary2);
            plotButton(2, primary1, drivers[2], primary2);
            plotButton(3, primary1, drivers[3], primary2);
            plotButton(4, secondary, drivers[4], primary2);
            break;
    }
}

void plotButton(int num, color fill, String driver, color text) {
    rectMode(CORNERS);
    stroke(accent);
    strokeWeight(3);
    textFont(f1_font);
    textSize(30);
    textAlign(CENTER, TOP);
    fill(fill);
    rect(buttons.get(num)[0], buttons.get(num)[1], buttons.get(num)[2], buttons.get(num)[3]);
    fill(text);
    text(driver, (buttons.get(num)[0] + buttons.get(num)[2]) / 2, (buttons.get(num)[1] + buttons.get(num)[3]) / 2 - 10);
}

void hover() {
    boolean check = false;
    for (int i = 0; i < buttons.size(); i++) {
        if (isHovering(i) && selection != i) {
            plotButton(i, stroke, drivers[i], primary2);
            check = true;
            if (mousePressed && i == 4) {
                is_dry = !is_dry;
                select(selection);
                delay(200); // Debouncing
                building = false;
                ratio = 1 - ratio;
            }
            else if (mousePressed) {
                selection = i;
                select(selection);
                building = false;
                ratio = 1 - ratio;
            }
        }
        else if (!check) {
            select(selection);
        }
    }
}

boolean isHovering(int num) {
    float midwidth = (buttons.get(num)[0] + buttons.get(num)[2]) / 2;
    float midheight = (buttons.get(num)[1] + buttons.get(num)[3]) / 2;
    float halfwidth = abs(buttons.get(num)[0] - buttons.get(num)[2]) / 2;
    float halfheight = abs(buttons.get(num)[1] - buttons.get(num)[3]) / 2;
    
    if(abs(mouseX - midwidth) < halfwidth && abs(mouseY - midheight) < halfheight) 
        return true;
    else
        return false;
}