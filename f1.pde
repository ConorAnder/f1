// Colour pallette
color background = color(13, 31, 60);
color primary1 = color(68, 255, 210);
color primary2 = color(255, 20, 0);
color secondary = color(255, 221, 74);
color accent = color(120, 120, 120);
color stroke = color(200, 200, 200);

// Fonts
PFont f1_font;
PFont graphing;

// Drivers
String[] drivers;

// Pixel coordinates for sections
int border;

int map_width_left, map_width_right;
int map_height_bottom, map_height_top;

int bar_width_left, bar_width_right;
int bar_height_bottom, bar_height_top;

int button_width_left, button_width_right;
int button_height_bottom, button_height_top;

int line_width_left, line_width_right;
int line_height_bottom, line_height_top;

// Tables from csv
Table hamilton_dry;
Table hamilton_wet;
Table leclerc_dry;
Table leclerc_wet;
Table tsunoda_dry;
Table tsunoda_wet;
Table russell_dry;
Table russell_wet;

// Animation frame indices
int track_index, size;
float ratio;
boolean building;

// Bar chart values
Pair<float[], int[]> hd_bar;
Pair<float[], int[]> hw_bar;
Pair<float[], int[]> ld_bar;
Pair<float[], int[]> lw_bar;
Pair<float[], int[]> td_bar;
Pair<float[], int[]> tw_bar;
Pair<float[], int[]> rd_bar;
Pair<float[], int[]> rw_bar;
Pair<float[], int[]> all_bar;
float dist_max, dist_min;
int brake_max;

Pair<float[], float[]> bar_heights;

// Number of bars in bar chart
int bin_nums = 10;

// Line chart values
Pair<float[], float[]> hd_line;
Pair<float[], float[]> hw_line;
Pair<float[], float[]> ld_line;
Pair<float[], float[]> lw_line;
Pair<float[], float[]> td_line;
Pair<float[], float[]> tw_line;
Pair<float[], float[]> rd_line;
Pair<float[], float[]> rw_line;
Pair<float[], float[]> all_line;
float speed_max, speed_min;

Pair<float[], float[]> line_graph;
String[] markers;

// Number of points in line chart
int point_nums = 10;

// Button control variables
ArrayList<float[]> buttons = new ArrayList<>();
int selection;
boolean is_dry;

void settings() {
    fullScreen();
}

void setup() {
    background(background);
    f1_font = createFont("Formula1-Regular.ttf", 32);
    graphing = createFont("Arial", 15);

    // Store driver names and track state
    drivers = new String[]{"Hamilton", "Leclerc", "Tsunoda", "Russell", "Dry"};

    // Load csvs into tables
    hamilton_dry = loadTable("hamilton_dry.csv", "header");
    hamilton_wet = loadTable("hamilton_wet.csv", "header");
    leclerc_dry = loadTable("leclerc_dry.csv", "header");
    leclerc_wet = loadTable("leclerc_wet.csv", "header");
    tsunoda_dry = loadTable("tsunoda_dry.csv", "header");
    tsunoda_wet = loadTable("tsunoda_wet.csv", "header");
    russell_dry = loadTable("russell_dry.csv", "header");
    russell_wet = loadTable("russell_wet.csv", "header");

    // Get number of samples
    size = hamilton_dry.getRowCount();

    // Load bar chart data
    hd_bar = getBarValues(hamilton_dry, size);
    hw_bar = getBarValues(hamilton_wet, size);
    ld_bar = getBarValues(leclerc_dry, size);
    lw_bar = getBarValues(leclerc_wet, size);
    td_bar = getBarValues(tsunoda_dry, size);
    tw_bar = getBarValues(tsunoda_wet, size);
    rd_bar = getBarValues(russell_dry, size);
    rw_bar = getBarValues(russell_wet, size);
    all_bar = new Pair<>(new float[0], new int[0]);
    all_bar = new Pair<>(concat(all_bar.first, hd_bar.first), concat(all_bar.second, hd_bar.second));
    all_bar = new Pair<>(concat(all_bar.first, hw_bar.first), concat(all_bar.second, hw_bar.second));
    all_bar = new Pair<>(concat(all_bar.first, ld_bar.first), concat(all_bar.second, ld_bar.second));
    all_bar = new Pair<>(concat(all_bar.first, lw_bar.first), concat(all_bar.second, lw_bar.second));
    all_bar = new Pair<>(concat(all_bar.first, td_bar.first), concat(all_bar.second, td_bar.second));
    all_bar = new Pair<>(concat(all_bar.first, tw_bar.first), concat(all_bar.second, tw_bar.second));
    all_bar = new Pair<>(concat(all_bar.first, rd_bar.first), concat(all_bar.second, rd_bar.second));
    all_bar = new Pair<>(concat(all_bar.first, rw_bar.first), concat(all_bar.second, rw_bar.second));

    // Set bar chart range
    dist_max = max(all_bar.first);
    dist_min = min(all_bar.first);
    brake_max = max(all_bar.second);

    // Load line chart data
    hd_line = getLineValues(hamilton_dry, size);
    hw_line = getLineValues(hamilton_wet, size);
    ld_line = getLineValues(leclerc_dry, size);
    lw_line = getLineValues(leclerc_wet, size);
    td_line = getLineValues(tsunoda_dry, size);
    tw_line = getLineValues(tsunoda_wet, size);
    rd_line = getLineValues(russell_dry, size);
    rw_line = getLineValues(russell_wet, size);
    all_line = new Pair<>(new float[0], new float[0]);
    all_line = new Pair<>(concat(all_line.first, hd_line.first), concat(all_line.second, hd_line.second));
    all_line = new Pair<>(concat(all_line.first, hw_line.first), concat(all_line.second, hw_line.second));
    all_line = new Pair<>(concat(all_line.first, ld_line.first), concat(all_line.second, ld_line.second));
    all_line = new Pair<>(concat(all_line.first, lw_line.first), concat(all_line.second, lw_line.second));
    all_line = new Pair<>(concat(all_line.first, td_line.first), concat(all_line.second, td_line.second));
    all_line = new Pair<>(concat(all_line.first, tw_line.first), concat(all_line.second, tw_line.second));
    all_line = new Pair<>(concat(all_line.first, rd_line.first), concat(all_line.second, rd_line.second));
    all_line = new Pair<>(concat(all_line.first, rw_line.first), concat(all_line.second, rw_line.second));

    // Set Line chart range
    speed_min = min(all_line.second);
    speed_max = max(all_line.second);

    // Set section dimensions
    border = 100;

    map_width_left = border; map_width_right = (2 * width / 3) - border;
    map_height_bottom = 7 * height / 12 - border; map_height_top = border;

    bar_width_left = int(1.5 * map_width_left); bar_width_right = width / 2 + bar_width_left;
    bar_height_bottom = height - map_height_top; bar_height_top = map_height_bottom + map_height_top;

    button_width_left = map_width_right + 2 * border; button_width_right = width - border;
    button_height_bottom = map_height_bottom; button_height_top = map_height_top;

    line_width_left = bar_width_right + border; line_width_right = width - border;
    line_height_bottom = bar_height_bottom; line_height_top = bar_height_top;

    // Initialise animation frame indices
    track_index = 0;
    ratio = 0;
    building = true;

    // Initialise buttons
    float button_height = (button_height_bottom - button_height_top) / 9.0;
    selection = 0;
    for (int i = 0; i < 9; i += 2) {
        float current_height = button_height_top + i * button_height;
        buttons.add(new float[]{button_width_left, current_height, button_width_right, current_height + button_height});
    }
    is_dry = true;


    // Line plot graphing
    plotLineTitles();
    markers = plotLineGrid(1, hw_line);

    // Bar chart graphing
    stroke(accent);
    strokeWeight(3);
    line(bar_width_left, bar_height_bottom, bar_width_left, bar_height_top);
    plotBarTitles();
    plotBarMarkers();

    // Initial button selection
    fill(primary2);
    stroke(primary2);
    select(0);
}

void draw() {
    if (is_dry) drivers[4] = "Dry";
    else drivers[4] = "Wet";

    if (building) {
        switch(selection) {
            case 0:
                line_graph = plotLineGraph(hd_line, hw_line, ratio);
                if(is_dry) {
                    plotPath(hamilton_dry, size);
                    bar_heights = plotBarChart(hd_bar, ratio);
                }
                else {
                    plotPath(hamilton_wet, size);
                    bar_heights = plotBarChart(hw_bar, ratio);
                }
                break;
            
            case 1:
                line_graph = plotLineGraph(ld_line, lw_line, ratio);
                if(is_dry) {
                    plotPath(leclerc_dry, size);
                    bar_heights = plotBarChart(ld_bar, ratio);
                }
                else {
                    plotPath(leclerc_wet, size);
                    bar_heights = plotBarChart(lw_bar, ratio);
                }
                break;

            case 2:
                line_graph = plotLineGraph(td_line, tw_line, ratio);
                if(is_dry) {
                    plotPath(tsunoda_dry, size);
                    bar_heights = plotBarChart(td_bar, ratio);
                }
                else {
                    plotPath(tsunoda_wet, size);
                    bar_heights = plotBarChart(tw_bar, ratio);
                }
                break;

            case 3:
                line_graph = plotLineGraph(rd_line, rw_line, ratio);
                if(is_dry) {
                    plotPath(russell_dry, size);
                    bar_heights = plotBarChart(rd_bar, ratio);
                }
                else {
                    plotPath(russell_wet, size);
                    bar_heights = plotBarChart(rw_bar, ratio);
                }
                break;

            default:
                line_graph = plotLineGraph(hd_line, hw_line, ratio);
                if(is_dry) {
                    plotPath(hamilton_dry, size);
                    bar_heights = plotBarChart(hd_bar, ratio);
                }
                else {
                    plotPath(hamilton_wet, size);
                    bar_heights = plotBarChart(hw_bar, ratio);
                }
                break;
        }
    }

    else {
        collapseBarChart(bar_heights, ratio);
        collapseLineGraph(ratio, line_graph);
        stroke(background);
        fill(background);
        rectMode(CORNERS);
        rect(map_width_left -2, map_height_bottom + 2, ratio * map_width_right + 2, map_height_top - 2);
        if (ratio >= 1) {
            ratio = 0;
            building = true;
            track_index = 0;
            plotBarMarkers();
        }
    }

    if (ratio < 1) {
        ratio += 0.05;
    }

    hover();
}