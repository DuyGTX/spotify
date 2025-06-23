// lib/presentation/home/bloc/outstanding_song_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/song/get_outstrading_song.dart';
import 'package:spotify/presentation/home/bloc/outstanding_song_state.dart';

class OutstandingSongCubit extends Cubit<OutstandingSongState> {
  final GetOutstradingSongUseCase useCase;

  OutstandingSongCubit(this.useCase) : super(OutstandingSongLoading());

  Future<void> getOutstandingSongs() async {
    final result = await useCase.call(); // ✅ không cần truyền params
    result.fold(
      (l) => emit(OutstandingSongLoadFailure()),
      (r) => emit(OutstandingSongLoaded(songs: r)),
    );
  }
}
