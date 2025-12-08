
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

Pair<float[], float[]> plotBarChart(Pair<float[], int[]> pair, float ratio) {
    rectMode(CORNERS);
    float[] dist_heights = new float[size];
    float[] brake_heights = new float[size];

    for (int i = 0; i < bin_nums; i++) {
        float dist_height = ratio * map(pair.first[i], dist_min, dist_max, 0, abs(bar_height_top - bar_height_bottom));
        float brake_height = dist_height * (float(pair.second[i]) / int(size / bin_nums));
        dist_heights[i] = dist_height;
        brake_heights[i] = brake_height;

        float bar_width = (bar_width_right - bar_width_left) / bin_nums;
        float bar_left = bar_width_left + i * bar_width;
        strokeWeight(3);
        stroke(stroke);
        fill(primary1);
        rect(bar_left, bar_height_bottom, bar_left + bar_width, bar_height_bottom - dist_height);

        fill(primary2);
        rect(bar_left, bar_height_bottom, bar_left + bar_width, bar_height_bottom - brake_height);
    }
    Pair<float[], float[]> bar_heights = new Pair<>(dist_heights, brake_heights);
    return bar_heights;
}

void collapseBarChart(Pair<float[], float[]> pair, float ratio) {
    strokeWeight(3);
    stroke(background);
    fill(background);
    rectMode(CORNERS);
    rect(bar_width_left, bar_height_bottom, bar_width_right, bar_height_top);

    for (int i = 0; i < bin_nums; i++) {
        float dist_height = (1 - ratio) * pair.first[i];
        float brake_height = (1 - ratio) * pair.second[i];

        float bar_width = (bar_width_right - bar_width_left) / bin_nums;
        float bar_left = bar_width_left + i * bar_width;
        stroke(stroke);
        fill(primary1);
        rect(bar_left, bar_height_bottom, bar_left + bar_width, bar_height_bottom - dist_height);

        fill(primary2);
        rect(bar_left, bar_height_bottom, bar_left + bar_width, bar_height_bottom - brake_height);
    }
}

void plotLineGraph(Pair<float[], float[]> paird, Pair<float[], float[]> pairw, float ratio) {
    float[] mapped_xd = new float[point_nums];
    float[] mapped_yd = new float[point_nums];

    float[] mapped_xw = new float[point_nums];
    float[] mapped_yw = new float[point_nums];

    float time_mind = min(paird.first), time_maxd = max(paird.first);
    float time_minw = min(pairw.first), time_maxw = max(pairw.first);

    for (int i = 0; i < point_nums; i++) {
        mapped_xd[i] = map(paird.first[i], time_mind, time_maxd, line_width_left, line_width_right);
        mapped_yd[i] = map(paird.second[i], speed_max, speed_min, line_height_bottom, line_height_top);
        mapped_xw[i] = map(pairw.first[i], time_minw, time_maxw, line_width_left, line_width_right);
        mapped_yw[i] = map(pairw.second[i], speed_max, speed_min, line_height_bottom, line_height_top);
    }

    int subdivisions = 100;
    int done = 0;
    for (int i = 0; i < point_nums - 1; i++) {
        for (int j = 0; j < subdivisions; j++) {
            if(done >= max(0, int(ratio * (point_nums - 1) * subdivisions))) {
                return;
            }

            float segment = j / float(subdivisions);
            float xd = lerp(mapped_xd[i], mapped_xd[i+1], segment);
            float yd = lerp(mapped_yd[i], mapped_yd[i+1], segment);
            float xw = lerp(mapped_xw[i], mapped_xw[i+1], segment);
            float yw = lerp(mapped_yw[i], mapped_yw[i+1], segment);

            strokeWeight(5);
            stroke(primary2);
            line(xd, yd, xd, yd);
            stroke(primary1);
            line(xw, yw, xw, yw);
            done++;
        }
    }
}

void collapseLineGraph(float ratio) {
    fill(background);
    stroke(background);
    rectMode(CORNERS);
    rect(line_width_right + 1, line_height_bottom + 1, line_width_right - ratio * abs(line_width_right - line_width_left) - 1, line_height_top - 1);
}