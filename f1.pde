color background = color(13, 31, 45);
color primary1 = color(68, 255, 210);
color primary2 = color(238, 108, 77);
color accent = color(255, 221, 74);
color stroke = color(119, 135, 139);

int map_width_left, map_width_right;
int map_height_bottom, map_height_top;

Table hamilton_dry;
Table hamilton_wet;
Table leclerc_dry;
Table leclerc_wet;
Table tsunoda_dry;
Table tsunoda_wet;
int track_index;

void settings() {
    // int page_height = 1000;
    // size(int(sqrt(2) * page_height), page_height);
    fullScreen();
}

void setup() {
    background(background);
    hamilton_dry = loadTable("hamilton_dry.csv", "header");
    hamilton_wet = loadTable("hamilton_wet.csv", "header");
    leclerc_dry = loadTable("leclerc_dry.csv", "header");
    leclerc_wet = loadTable("leclerc_wet.csv", "header");
    tsunoda_dry = loadTable("tsunoda_dry.csv", "header");
    tsunoda_wet = loadTable("tsunoda_wet.csv", "header");

    map_width_left = 100; map_width_right = 2 * width / 3;
    map_height_bottom = 7 * height / 12 - 50; map_height_top = 50;

    track_index = 0;
    //plotMap(hamilton_dry, hamilton_dry.getRowCount());
}

void draw() {
    int size = hamilton_dry.getRowCount();
    boolean flag = false;
    if(flag || plotPath(hamilton_dry, size)) {
        flag = true;
        plotPath(hamilton_wet, size);
        print("Here\n");
    }
}