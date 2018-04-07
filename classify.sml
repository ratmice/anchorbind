structure AnchDirToolClassify = struct
    val class = "anchor_dir"
    local
        open Tools
        fun classify { name, mkfname } =
            (if OS.FileSys.isDir (mkfname ()) then SOME class
             else NONE)
            handle _ => NONE
    in
        val _ = registerClassifier (GEN_CLASSIFIER classify)
    end
end

