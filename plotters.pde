void plotMap(Table driver_table, int size) {
    float offset = 250;
    float[] x = new float[size + 1];
    float[] y = new float[size + 1];
    float[] lx = new float[size + 1];
    float[] ly = new float[size + 1];
    float[] rx = new float[size + 1];
    float[] ry = new float[size + 1];
    for (int i = 0; i < size; i++) {
        float curr_x = driver_table.getFloat(i, "X");
        float curr_y = driver_table.getFloat(i, "Y");
        if (!Float.isNaN(curr_x) && !Float.isNaN(curr_y) && int(curr_x) != 0) {
            x[i] = driver_table.getFloat(i, "X");
            y[i] = driver_table.getFloat(i, "Y");
        }
    }

    int it = 0;
    while (int(x[it]) == 0) {
        it++;
        if (int(x[it]) != 0) {
            continue;
        }
        int it2 = it;
        while (it2 >= 0) {
            x[it2] = x[it];
            y[it2] = y[it];
            it2--;
        }
        x[size] = x[0];
        y[size] = y[0];
    }
        

    for (int i = 0; i < size; i++) {
        float dx = x[i+1] - x[i];
        float dy = y[i+1] - y[i];

        float len = sqrt(dx*dx + dy*dy);
        if (len == 0) {
            try{
                lx[i] = lx[i - 1];
                ly[i] = ly[i - 1];
                rx[i] = rx[i - 1];
                ry[i] = ry[i - 1];
                continue;
            }
            catch (Exception e) {
                continue;
            }
        }
        float nx = -dy / len;
        float ny = dx / len;

        lx[i] = x[i] + nx * offset;
        ly[i] = y[i] + ny * offset;
        rx[i] = x[i] - nx * offset;
        ry[i] = y[i] - ny * offset;
    }
    lx[0] = lx[1];
    ly[0] = ly[1];
    lx[size] = lx[0];
    ly[size] = ly[0];
    rx[0] = rx[1];
    ry[0] = ry[1];
    rx[size] = rx[0];
    ry[size] = ry[0];

    stroke(accent);
    fill(background);
    strokeWeight(1);
    float minx = min(x), miny = min(y), maxx = max(x), maxy = max(y);

    beginShape();
    for (int i = 0; i < size; i++) {
        float lx_point = map(lx[i], minx, maxx, map_width_left, map_width_right);
        float ly_point = map(ly[i], miny, maxy, map_height_bottom, map_height_top);
        curveVertex(lx_point, ly_point);
    }
    endShape(CLOSE);

    stroke(accent);
    fill(background);
    beginShape();
    for (int i = 0; i < size; i++) {
        float rx_point = map(rx[i], minx, maxx, map_width_left, map_width_right);
        float ry_point = map(ry[i], miny, maxy, map_height_bottom, map_height_top);
        curveVertex(rx_point, ry_point);
    }
    endShape(CLOSE);
}

boolean plotPath(Table driver_table, int size) {
    float[] x = new float[size + 1];
    float[] y = new float[size + 1];
    float[] s = new float[size + 1];
    for (int i = 0; i < size; i++) {
        float curr_x = driver_table.getFloat(i, "X");
        float curr_y = driver_table.getFloat(i, "Y");
        float curr_s = driver_table.getFloat(i, "Speed");
        if (!Float.isNaN(curr_x) && !Float.isNaN(curr_y) && int(curr_x) != 0) {
            x[i] = curr_x;
            y[i] = curr_y;
            s[i] = curr_s;
        }
    }

    // Remove leading zeroes
    int it = 0;
    while (int(x[it]) == 0) {
        it++;
        if (int(x[it]) == 0) {
            continue;
        }
        int it2 = it;
        while (it2 >= 0) {
            s[it2] = s[it];
            x[it2] = x[it];
            y[it2] = y[it];
            it2--;
        }
    }

    // Remove middle zeroes
    for (it = 1; it < size; it++) {
        if(int(x[it-1]) == 0) {
            x[it-1] = x[it];
            y[it-1] = y[it];
        }
    }

    // Remove trailing zeroes
    it = size;
    while (int(x[it]) == 0) {
        it--;
        if (int(x[it]) == 0) {
            continue;
        }
        int it2 = it;
        while (it2 <= size) {
            s[it2] = s[it];
            x[it2] = x[it];
            y[it2] = y[it];
            it2++;
        }
        s[size] = s[0];
        x[size] = x[0];
        y[size] = y[0];
    }

    strokeWeight(3);
    float minx = min(x), miny = min(y), maxx = max(x), maxy = max(y);
    float mins = min(s), maxs = max(s);

    int i = track_index;
    if (frameCount % 1 == 0 && track_index < size) {
        float x1 = map(x[i], minx, maxx, map_width_left, map_width_right);
        float y1 = map(y[i], miny, maxy, map_height_bottom, map_height_top);
        float x2 = map(x[i+1], minx, maxx, map_width_left, map_width_right);
        float y2 = map(y[i+1], miny, maxy, map_height_bottom, map_height_top);
        float colour = map(s[i], mins, maxs, 0, 1);
        stroke(lerpColor(primary1, primary2, colour));
        line(x1, y1, x2, y2);
        track_index++;
    }
    else if(track_index >= size) {
        track_index = 0;
        return true;
    }
    return false;
}

void plotBarChart(Pair<float[], int[]> pair, int ratio) {
    rectMode(CORNERS);
    float dist_max = max(pair.first), dist_min = min(pair.first);
    int brake_max = max(pair.second), brake_min = min(pair.second);
    for (int i = 0; i < bin_nums; i++) {
        float dist_height = ratio * map(pair.first[i], dist_min, dist_max, bar_height_bottom, bar_height_top);
        float brake_height = map(pair.second[i], brake_min, brake_max, bar_height_bottom, dist_height);
        // print("Dist Min: " + str(dist_min) + " Dist Max: " + str(dist_max) + " Brake Min: " + str(brake_min) + " Brake Max: " + str(brake_max) + "\n");
        // print("Dist: " + str(pair.first[i]) + " Brake: " + str(pair.second[i]) + "\n");
        // print("Dist Height -> " + str(dist_height) + " Brake Height -> " + str(brake_height) + "\n\n");

        fill(primary2);
        rect(bar_width_left + (i / float(bin_nums)) * bar_width_right, bar_height_bottom, bar_width_left + ((i + 1) / bin_nums) * bar_width_right, dist_height);

        fill(primary1);
        rect(bar_width_left + (i / float(bin_nums)) * bar_width_right, bar_height_bottom, bar_width_left + ((i + 1) / bin_nums) * bar_width_right, brake_height);
    }
}