using System.Text;
using Raylib.Bindings;

namespace Raylib.Example;

public static class Program
{
    public static unsafe void Main()
    {
        Console.WriteLine("Initializing Window...");

        // fixed (byte* p = Encoding.UTF8.GetBytes("Raylib Example\0"))
        // {
        //     Bindings.Raylib.InitWindow(800, 450, (sbyte*)p);
        // }

        Bindings.Raylib.InitWindow(800, 450, "Raylib Example Safe");

        while (Bindings.Raylib.WindowShouldClose() == 0)
        {
            Bindings.Raylib.BeginDrawing();
            Bindings.Raylib.ClearBackground(
                new Color
                {
                    r = 255,
                    g = 0,
                    b = 255,
                    a = 255,
                }
            );
            fixed (byte* p = Encoding.UTF8.GetBytes("If you see this, the automation worked!"))
            {
                Bindings.Raylib.DrawText(
                    (sbyte*)p,
                    190,
                    200,
                    20,
                    new Color
                    {
                        r = 0,
                        g = 0,
                        b = 0,
                        a = 255,
                    }
                );
            }
            Bindings.Raylib.EndDrawing();
        }

        Bindings.Raylib.CloseWindow();
    }
}
