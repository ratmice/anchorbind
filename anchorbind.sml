structure AnchorBind = struct
  structure FS = OS.FileSys;
  structure Path = OS.Path;
  fun readDirEntries (dirName, dir, acc) =
    let 
	val entry = FS.readDir dir;
	fun handleDirEntry (dir, SOME entry, acc) = readDirEntries(dirName, dir, entry::acc)
	  | handleDirEntry (dir, NONE, acc)	  = readDirEntries(dirName, dir, acc)

	fun checkEntries (dir, NONE, acc) = acc
	  | checkEntries (dir, SOME entry, acc) =
	   let val path = Path.joinDirFile{dir=dirName, file=entry}
	    in if String.isPrefix "." entry = false andalso FS.isDir (path)
	         then handleDirEntry(dir, SOME(path), acc)
	         else handleDirEntry(dir, NONE, acc)
	   end
     in checkEntries(dir, entry, acc) end

  fun go([], acc) = acc
    | go(dirName::dirs, acc) =
      let val dir = FS.openDir dirName;
	  val dirEnts = readDirEntries(dirName, dir, acc); 
	  val () = FS.closeDir(dir); 
       in go(dirs, dirEnts) end

  fun addBindings([]) 		= ()
    | addBindings(path::paths)	= 
	let val anchor = (Path.file path)
	    val () = print ("Anchor: " ^ anchor ^ " bound to: " ^ path ^ "\n")
	 in (#set (CM.Anchor.anchor anchor)) (SOME path) end


  (* fun binddirRule { spec, context, native2pathmaker, defaultClassOf, sysinfo } = { smlfiles = [], cmfiles = [], sources = [] } *)
  fun rule { spec as { name, mkpath, opts, ...} : Tools.spec, context, native2pathmaker, defaultClassOf, sysinfo }
    = let
          val pre_d = mkpath ()
          val spec_d = Tools.nativePreSpec pre_d
          val () = print ("scanning: " ^ spec_d ^ "\n")
	  val () = addBindings(go ([spec_d],[]));
       in ({ smlfiles = [], cmfiles = [], sources = [] }, [])
      end
  
  val _ = Tools.registerClass(AnchDirToolClassify.class, rule);
end
