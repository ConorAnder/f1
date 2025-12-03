void plotMap() {

}

void plotPath(Table driver_table, int size) {
    float[] x = new float[size + 1];
    float[] y = new float[size + 1];
    for (int i = 0; i < driver_table.getRowCount(); i++) {
        float curr_x = driver_table.getFloat(i, "X");
        float curr_y = driver_table.getFloat(i, "Y");
        if (!Float.isNaN(curr_x) && !Float.isNaN(curr_y) && int(curr_x) != 0) {
            x[i] = driver_table.getFloat(i, "X");
            y[i] = driver_table.getFloat(i, "Y");
        }
    }
    x[0] = x[1];
    y[0] = y[1];
    x[size] = x[0];
    y[size] = y[0];

    stroke(primary1);
    strokeWeight(3);
    float minx = min(x), miny = min(y), maxx = max(x), maxy = max(y);

    int i = track_index;
    if (frameCount % 1 == 0 && track_index < size) {
        float x1 = map(x[i], minx, maxx, 100, width - 100);
        float y1 = map(y[i], miny, maxy, height - 100, 100);
        float x2 = map(x[i+1], minx, maxx, 100, width - 100);
        float y2 = map(y[i+1], miny, maxy, height - 100, 100);
        line(x1, y1, x2, y2);
        track_index++;
    }
    else if(track_index >= size) {
        noLoop();
    }
}