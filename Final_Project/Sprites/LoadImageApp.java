import javax.imageio.ImageIO;
import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;

public class LoadImageApp{
    ArrayList<String> filenames;
    HashMap<Color,Integer> palette;
    int numPaletteEntries;

    public static int roundOffTens(int n)
     {
        // Get the right most digit 
        int rdigit=n%10;

        // If right digit greater than 5
        if(rdigit>5)
            n+=10-rdigit;
        else
            n-=rdigit;

        // Return the value
        return n;
     }  

    private void establishPalette() throws IOException {
        int currentIndex = 0;

        for (String filename : filenames) {
            BufferedImage spritePNG = ImageIO.read(new File(filename + ".png"));
            for (int x = 0; x < spritePNG.getWidth(); x++) {
                for (int y = 0; y < spritePNG.getHeight(); y++) {
                    Color c = new Color(spritePNG.getRGB(x, y));
                    int red_val = roundOffTens(c.getRed());
                    int green_val = roundOffTens(c.getGreen());
                    int blue_val = roundOffTens(c.getBlue());
                    Color c_trunc = new Color(red_val, green_val, blue_val);


                    if (!palette.containsKey(c_trunc)) {
                        palette.put(c_trunc, currentIndex);
                        currentIndex++;
                        System.out.println(c_trunc);
                    }
                }
            }
        }

        numPaletteEntries = currentIndex;
        System.out.println("Total colors: " + currentIndex);
    }

    private void outputPalette() throws IOException {
        int[][] paletteArray = new int[numPaletteEntries+1][3];
        for (Color c : palette.keySet()) {
            paletteArray[palette.get(c)][0] = roundOffTens(c.getRed());
            paletteArray[palette.get(c)][1] = roundOffTens(c.getGreen());
            paletteArray[palette.get(c)][2] = roundOffTens(c.getBlue());
        }

        PrintStream paletteSV = new PrintStream(new FileOutputStream("palette.sv"));

        paletteSV.println("module palette(output logic [7:0] palette[0:" + numPaletteEntries + "][0:2]);");
        paletteSV.print("assign palette = '{");

        for (int i = 0; i < numPaletteEntries+1; i++) {
            paletteSV.print("'{");
            for (int j = 0; j < 3; j++) {

                paletteSV.print(verilogColor(paletteArray[i][j]));
                if (j != 2) {
                    paletteSV.print(",");
                }
            }
            paletteSV.print("}");

            if (i != numPaletteEntries) {
                paletteSV.print(",");
            }
        }

        paletteSV.println("};");
        paletteSV.println("endmodule");
    }

    private void outputSVs() throws IOException {
        for (String filename : filenames) {
            BufferedImage spritePNG = ImageIO.read(new File(filename + ".png"));
            System.out.println(spritePNG.getWidth() + " " + spritePNG.getHeight());
            PrintStream spriteSV = new PrintStream(new FileOutputStream(filename + ".sv"));

            spriteSV.println("module " + filename + "(output logic [" + getRequiredInt() + ":0] rgb[0:" + (spritePNG.getWidth() - 1) + "][0:" + (spritePNG.getHeight() - 1) + "]);");
            spriteSV.println("assign rgb = '{");

            for (int x = 0; x < spritePNG.getWidth(); x++) {
                spriteSV.println("'{");
                for (int y = 0; y < spritePNG.getHeight(); y++) {
                    Color c = new Color(spritePNG.getRGB(x, y));
                    int red_val = roundOffTens(c.getRed());
                    int green_val = roundOffTens(c.getGreen());
                    int blue_val = roundOffTens(c.getBlue());
                    Color c_trunc = new Color(red_val, green_val, blue_val);

                    spriteSV.print(""+verilogNumber(palette.get(c_trunc)));

                    if (y != spritePNG.getHeight() - 1) {
                        spriteSV.print(",");
                    }
                }
                spriteSV.println();
                spriteSV.print("}");

                if (x != spritePNG.getWidth() - 1) {
                    spriteSV.println(",");
                }
            }

            spriteSV.println("};");
            spriteSV.println("endmodule");
        }
    }

    private int getRequiredInt() {
        return (int) Math.ceil(Math.log(numPaletteEntries + 1)/Math.log(2));
    }

    public LoadImageApp(ArrayList<String> filenames) throws IOException {
        this.filenames = filenames;
        palette = new HashMap<Color, Integer>();
        establishPalette();
        outputPalette();
        outputSVs();
        outputRAM();
    }

    private void outputRAM() throws IOException {
        BufferedImage backgroundPNG = ImageIO.read(new File("background.png"));
        DataOutputStream backgroundStream = new DataOutputStream(new FileOutputStream("background.ram"));

        for (int y = 0; y < backgroundPNG.getHeight(); y++) {
            for (int x = 0; x < backgroundPNG.getWidth(); x++) {
                Color c = new Color(backgroundPNG.getRGB(x, y));
                int red_val = roundOffTens(c.getRed());
                int green_val = roundOffTens(c.getGreen());
                int blue_val = roundOffTens(c.getBlue());
                Color c_trunc = new Color(red_val, green_val, blue_val);

                int num = palette.get(c_trunc);
                int c1 = (num >> 8) & 0xff;
                int c2 = (num & 0xff);
                backgroundStream.writeByte(c2);
                backgroundStream.writeByte(c1);
            }
        }

        backgroundStream.close();
    }

    private String verilogNumber(int number) {
        return "" + getRequiredInt() + "'d" + number;
    }

    private String verilogColor(int color) {
        return "8'd" + color;
    }

    public static void main(String[] args) {
        try {
            ArrayList<String> l = new ArrayList<String>();
            l.add("images/frog_sprite");
            l.add("images/lilypad_sprite");
            l.add("images/carright_sprite");
            l.add("images/carleft_sprite");
            l.add("images/numbers");
            
            LoadImageApp frogger = new LoadImageApp(l);
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
