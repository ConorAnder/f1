
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
        stroke(accent);
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
        stroke(accent);
        fill(primary1);
        rect(bar_left, bar_height_bottom, bar_left + bar_width, bar_height_bottom - dist_height);

        fill(primary2);
        rect(bar_left, bar_height_bottom, bar_left + bar_width, bar_height_bottom - brake_height);
    }
}

void plotLineGrid(float ratio, Pair<float[], float[]> values) {
    stroke(accent);
    strokeWeight(3);
    int box_nums = 4;
    float graph_width = line_width_right - line_width_left;
    float graph_height = line_height_bottom - line_height_top;
    float box_width = graph_width / point_nums;
    float box_height = graph_height / box_nums;

    // Vertical gridlines
    line(line_width_left - 2, line_height_bottom - 2, line_width_left - 2, line_height_top);
    line(line_width_right + 10, line_height_bottom - 2, line_width_right + 10, line_height_top);

    // Horizontal gridlines
    strokeWeight(1);
    line(line_width_right - ratio * graph_width - 2, line_height_bottom - 2, line_width_right + 10, line_height_bottom - 2);
    for (int i = 0; i < box_nums; i++) {
        line(line_width_right - ratio * graph_width - 2, line_height_top + i * box_height, line_width_right + 10, line_height_top + i * box_height);
    }

    // X axis markers
    if (ratio == 1) {
        fill(accent);
        textAlign(CENTER);
        textFont(graphing);
        text("0:00", line_width_left, line_height_bottom + 20);
        for (int i = 1; i <= point_nums; i++) {
            float box_pos = line_width_left + i * box_width;
            String marker, minutes, seconds;
            if (values.first[point_nums - 1] > values.second[point_nums - 1]) {
                minutes = str(int(values.first[i - 1]) / 60);
                seconds = (int(values.first[i - 1]) % 60 < 10) ? "0" + str(int(values.first[i - 1]) % 60) : str(int(values.first[i - 1]) % 60);
                marker = minutes + ":" + seconds;
            }
            else {
                minutes = str(int(values.second[i - 1]) / 60);
                seconds = (int(values.second[i - 1]) % 60 < 10) ? "0" + str(int(values.second[i - 1]) % 60) : str(int(values.second[i - 1]) % 60);
                marker = minutes + ":" + seconds;
            }

            text(marker, box_pos, line_height_bottom + 20);
        }
    }
}

Pair<float[], float[]> plotLineGraph(Pair<float[], float[]> paird, Pair<float[], float[]> pairw, float ratio) {
    float[] mapped_xd = new float[point_nums];
    float[] mapped_yd = new float[point_nums];

    float[] mapped_xw = new float[point_nums];
    float[] mapped_yw = new float[point_nums];

    float time_min = min(concat(paird.first, pairw.first)), time_max = max(concat(paird.first, pairw.first));
    Pair<float[], float[]> time_pair = new Pair<float[], float[]>(pairw.first, paird.first);

    for (int i = 0; i < point_nums; i++) {
        mapped_xd[i] = map(paird.first[i], time_min, time_max, line_width_left, line_width_right);
        mapped_yd[i] = map(paird.second[i], speed_max, 0, line_height_top, line_height_bottom);
        mapped_xw[i] = map(pairw.first[i], time_min, time_max, line_width_left, line_width_right);
        mapped_yw[i] = map(pairw.second[i], speed_max, 0, line_height_top, line_height_bottom);
    }

    int subdivisions = 100;
    int done = 0;
    for (int i = 0; i < point_nums - 1; i++) {
        for (int j = 0; j < subdivisions; j++) {
            if(done >= max(0, int(ratio * (point_nums - 1) * subdivisions))) {
                return time_pair;
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
    return time_pair;
}

void collapseLineGraph(float ratio, Pair<float[], float[]> graph) {
    fill(background);
    stroke(background);
    rectMode(CORNERS);
    rect(width, height, line_width_right - ratio * abs(line_width_right - line_width_left) - 15, line_height_top - 1);
    plotLineGrid(ratio, graph);
}