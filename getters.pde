// Why doesn't processing have tuples?
class Pair<A, B> {
    A first;
    B second;

    Pair(A first, B second) {
        this.first = first;
        this.second = second;
    }
}

Pair<float[], int[]> getBarValues(Table driver_table, int size) {
    int bin_size = int(size / bin_nums);
    int brake_freq[] = new int[bin_nums];
    float dist[] = new float[bin_nums];

    for (int j = 0; j < bin_nums; j++) {
        for (int i = 0; i < bin_size; i++) {
            if(driver_table.getString(j * bin_size + i, "Brake").equals("True")) {
                brake_freq[j]++;
            }
        }
        dist[j] = driver_table.getFloat((j + 1) * bin_size - 1, "Distance") - driver_table.getFloat(j * bin_size, "Distance");
        // print("Brake: " + str(brake_freq[j]));
        // print(" Dist: " + str(dist[j]) + "\n");
    }
    Pair<float[], int[]> pair = new Pair<>(dist, brake_freq);
    return pair;
}

Pair<float[], float[]> getLineValues(Table driver_table, int size) {
    int avgd_points = int(size / point_nums);
    float[] time = new float[point_nums];
    float[] speed = new float[point_nums];
    for (int i = 0; i < point_nums; i++) {
        float time_sum = 0;
        float speed_sum = 0;
        for (int j = 0; j < avgd_points; j++) {
            time_sum += driver_table.getFloat(i * avgd_points + j, "Time");
            speed_sum += driver_table.getFloat(i * avgd_points + j, "Speed");
        }
        time[i] = time_sum / avgd_points;
        speed[i] = speed_sum / avgd_points;
    }

    Pair<float[], float[]> pair = new Pair<>(time, speed);
    return pair;
}