# Shared helpers for NVF configuration.
{
  # Command helper (wraps in <cmd>...<cr>)
  cmd = c: "<cmd>${c}<cr>";

  # Normal mode keymap
  nmap = key: action: desc: {
    inherit key action desc;
    mode = "n";
  };

  # Normal mode with lua action (wrapped in function)
  nmapLua = key: action: desc: {
    inherit key desc;
    mode = "n";
    lua = true;
    action = "function() ${action} end";
  };

  # Multi-mode keymap
  map = modes: key: action: desc: {
    inherit key action desc;
    mode = modes;
  };

  # Multi-mode with lua action (wrapped in function)
  mapLua = modes: key: action: desc: {
    inherit key desc;
    mode = modes;
    lua = true;
    action = "function() ${action} end";
  };

  # Snacks helpers
  snacks = module: "Snacks.${module}";
  snacksPicker = picker: "Snacks.picker.${picker}()";
  snacksPickerOpts = picker: opts: "Snacks.picker.${picker}(${opts})";
}
