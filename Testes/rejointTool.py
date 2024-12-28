import psutil
import ctypes
import time
import os

def is_roblox_open():
    """Check if Roblox is running as a process."""
    for process in psutil.process_iter(['name']):
        if "RobloxPlayerBeta.exe" in process.info['name']:
            return process
    return None

def is_window_frozen(pid):
    """Check if a Roblox process is frozen (not responding)."""
    try:
        roblox_process = psutil.Process(pid)
        if roblox_process.status() == psutil.STATUS_STOPPED:
            return True

        hwnd = ctypes.windll.user32.FindWindowW(None, "Roblox")
        if hwnd:
            is_responding = ctypes.windll.user32.IsWindow(hwnd)
            return not bool(is_responding)
    except Exception as e:
        print(f"Error checking if window is frozen: {e}")
        return False
    return False

def open_roblox(place_id):
    """Open Roblox with a specific place ID."""
    url = f"roblox://placeId={place_id}"
    try:
        os.startfile(url)
        print(f"Tentando abrir Roblox com o placeId: {place_id}")
    except Exception as e:
        print(f"Erro ao tentar abrir Roblox: {e}")

def main():
    place_id = 8304191830  # Substitua pelo ID do lugar desejado
    while True:
        roblox_process = is_roblox_open()
        if roblox_process:
            pid = roblox_process.pid
            if is_window_frozen(pid):
                print("Roblox está congelado!")
                open_roblox(place_id)
        else:
            print("Roblox não está aberto.")
            open_roblox(place_id)

        time.sleep(5)  # Verificar a cada 5 segundos

if __name__ == "__main__":
    main()