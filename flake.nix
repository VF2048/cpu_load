{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/release-26.05";
    };
      
    outputs = { self, nixpkgs }:
        let
          # Укажите вашу архитектуру (например, aarch64-linux для ARM)
          system = "x86_64-linux"; 
          pkgs = nixpkgs.legacyPackages.${system};
         Cab = pkgs.llvmPackages_latest; # Можно заменить на llvmPackages_X или gcc
        in
        {
          devShells.${system}.default = pkgs.mkShell {
            # Пакеты, которые будут доступны в проекте
            packages = with pkgs; [
              clang-tools          # LSP (clangd), форматирование (clang-format)
              cmake                # Система сборки
              gnumake              # Make (если нужен вместо ninja)
              
              # Пример библиотеки C++ из репозитория Nix
              nlohmann_json        
            ];

            # Нативные зависимости (компилятор)
            nativeBuildInputs = [ Cab.stdenv.cc ];

            shellHook = ''
              echo "Welcome to your C++ development environment!"
              echo "Compiler: $(clang++ --version | head -n 1)"
            '';
          };
        };
}
